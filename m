Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0CRHLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 03:11:38 -0400
Received: from psi.thgersdorf.net ([188.40.92.130]:52901 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0CRHLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:11:36 -0400
Date: Thu, 18 Mar 2010 08:11:31 +0100
From: Dieter Ries <mail@dieterries.net>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Message-ID: <20100318071131.GC24062@Localhorst.asterix.local>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
 <1258373983-8693-24-git-send-email-avi@redhat.com>
 <4BA1504A.3090801@dieterries.net>
 <808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
 <20100317224002.GA5156@Localhorst.asterix.local>
 <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 11:47:14PM +0100, Alexander Graf wrote:
> It looks like one of your CPUs has EFER_SVME enabled on bootup already. I'm not aware of code clearing EFER, so if there's garbage in there on boot it stays there.
> 
> Could you please add the current CPU number to your printk? I bet it's always the same one.

[ 1300.393635] efer on CPU1 is d01
[ 1300.393638] efer on CPU3 is d01
[ 1300.393641] efer on CPU2 is d01
[ 1300.393643] EFER_SVME is 1000
[ 1300.393645] EFER_SVME is 1000
[ 1300.393646] EFER_SVME is 1000
[ 1300.393650] efer on CPU0 is 1d01
[ 1300.393652] EFER_SVME is 1000
[ 1300.393653] kvm: enabling virtualization on CPU0 failed


> If that's the case I'd say you have a broken BIOS or bootloader.

You are right, it seems to be always cpu0. I'll check my BIOS and flash
a newer version if available.
 
> 
> Alex

cu
Dieter


