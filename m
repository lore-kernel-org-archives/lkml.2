Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0KCALb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 20:11:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0KCALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 20:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hLGjLMulVTCO6oGMW9YxRB6C1nJB7LZy7sgoQYGEYtHrAjc+6Qu65zY3YSIwXUNULt
         5KRpQQDgpy+DM3KMIiog==
MIME-Version: 1.0
In-Reply-To: <20101102222030.GI7198@redhat.com>
References: <20101102222030.GI7198@redhat.com>
Date: Tue, 2 Nov 2010 17:11:24 -0700
Message-ID: <AANLkTi=U4MY1jEE60arAPz0iKbVcV__3WfHjU3eikaeh@mail.gmail.com>
Subject: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Nauman Rafique <nauman@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 3:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o Allow hierarchical cgroup creation for blkio controller

Vivek,

This patch looks fine, and we use similar code.  I'd be even more
interested in directing effort at Gui's patchset that fully implements
hierarchy.  If there are specific details that are blocking adoption
of that code, let's address them.

Chad
