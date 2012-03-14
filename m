Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab2CNKxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:53:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2CNKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:53:10 -0400
Message-ID: <4F60788A.2070608@redhat.com>
Date: Wed, 14 Mar 2012 12:52:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: Amit Shah <amit.shah@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <20120314103755.GD2708@amit.redhat.com> <4F607857.50402@cn.fujitsu.com>
In-Reply-To: <4F607857.50402@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 12:52 PM, Wen Congyang wrote:
> > 
> >> If so, is this channel visible to guest userspace? If the channle is visible to guest
> >> userspace, the program running in userspace may write the same message to the channel.
> > 
> > Access control is via permissions.  You can have udev scripts assign
> > whatever uid and gid to the port of your interest.  By default, all
> > ports are only accessible to the root user.
>
> We should also prevent root user writing message to this channel if it is
> used for panicked notification.
>

Why?  root can easily cause a panic.

-- 
error compiling committee.c: too many arguments to function

