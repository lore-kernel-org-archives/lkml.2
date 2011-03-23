Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1CWR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:26:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1CWR0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:26:23 -0400
Date: Wed, 23 Mar 2011 18:17:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 7/8] job control: Notify the real parent of job control
	events regardless of ptrace
Message-ID: <20110323171722.GA25011@redhat.com>
References: <1299614199-25142-8-git-send-email-tj@kernel.org> <20110321174306.GA29895@redhat.com> <20110322080444.GM12003@htj.dyndns.org> <20110322194416.GC28038@redhat.com> <20110323091736.GY12003@htj.dyndns.org> <20110323092455.GZ12003@htj.dyndns.org> <20110323164657.GB22527@redhat.com> <20110323165907.GE12003@htj.dyndns.org> <20110323170708.GA24304@redhat.com> <20110323172025.GG12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323172025.GG12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> > Hmm. So I misunderstood you. And still can't understand...
> >
> > Could you explain how should we change do_notify_parent_cldstop()?
> > I am just curious.
>
> As you suggested above. :-) The inconsistency I'm concernced about is
> the following.

Ah! got it. I misread you email as if I missed your initial point, sorry.

Oleg.

