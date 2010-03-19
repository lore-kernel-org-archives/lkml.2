Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0CSC1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:27:10 -0400
Received: from psi.thgersdorf.net ([188.40.92.130]:53826 "EHLO mail.psioc.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab0CSC1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:27:06 -0400
Date: Fri, 19 Mar 2010 03:26:59 +0100
From: Dieter Ries <mail@dieterries.net>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Message-ID: <20100319022659.GA13117@Localhorst.asterix.local>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
 <1258373983-8693-24-git-send-email-avi@redhat.com>
 <4BA1504A.3090801@dieterries.net>
 <808FF008-53B9-4271-904C-117A24ADF18C@suse.de>
 <20100317224002.GA5156@Localhorst.asterix.local>
 <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
 <20100318071131.GC24062@Localhorst.asterix.local>
 <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCA075C-F95E-4FEB-BECA-15D43E1DC1AB@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 08:17:01AM +0100, Alexander Graf wrote:
> On 18.03.2010, at 08:11, Dieter Ries wrote:
> > You are right, it seems to be always cpu0. I'll check my BIOS and flash
> > a newer version if available.
> 
> Please do. If that doesn't help ping me again. I'll write up a quirk patch then.

It seems you were right, I flashed the BIOS to the latest version and
now it is working.

So thanks everybody, and sorry for the inconvenience.

> Alex

cu
Dieter

