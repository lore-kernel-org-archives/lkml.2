Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2DVK5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 06:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2DVK5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 06:57:43 -0400
Message-ID: <4F93E411.7070809@redhat.com>
Date: Sun, 22 Apr 2012 13:57:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, dzickus@redhat.com,
        luto@mit.edu, gregkh@suse.de, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mtosatti@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        ludwig.nussel@suse.de
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F8FF7AC.1060309@redhat.com> <20120419.210119.246504497.d.hatayama@jp.fujitsu.com> <4F900020.5010702@redhat.com> <20120420.191133.488341439.d.hatayama@jp.fujitsu.com> <4F93D64B.50803@redhat.com> <20120422103340.GE12768@redhat.com>
In-Reply-To: <20120422103340.GE12768@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 01:33 PM, Gleb Natapov wrote:
> > 
> > What I don't understand is why you are interested in the guest machine
> > at all, if it was qemu that crashed.
> > 
> It would be interesting to extract enough information from the core to be
> able to restart the guest from the point where qemu crashed, but
> decoding VMCS is not enough for that.

Interesting idea.  It should be possible if you attach all kvm state to
the core (and do quite a lot of digging to recover device model state).

-- 
error compiling committee.c: too many arguments to function

