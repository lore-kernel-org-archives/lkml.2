Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1EQAr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 20:47:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52487 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EQArZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 20:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lFlR3MhEhQiJwB8TtCrodKvmnkSy2NnX/tRDmzKbjOlZk2ru+mvt5cMEvCgwkPGrX9
         qlyQlw+5elSPbKEk9AKUkL5JCScBAAXRXztlVfVuMRYHcls7xuA8ymbNjTEF74oDaypz
         MmarcAtR5M5WHdVgidjCcjY8sHAsr3NIzuwUg=
MIME-Version: 1.0
In-Reply-To: <BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
References: <1305317680.21099.83.camel@dwillia2-linux>
	<BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
	<4DCDA663.2040202@intel.com>
	<1305324962.2781.5.camel@pasglop>
	<BANLkTimYfjz=vhF=cGXNqRD1RTzKTGhv9w@mail.gmail.com>
Date: Mon, 16 May 2011 20:47:24 -0400
X-Google-Sender-Auth: h4U7egTRt5Jqe-2z3nJqj68tk2w
Message-ID: <BANLkTi=yGe+xKpB+VnD3+tvw1-o4Qs_Z7w@mail.gmail.com>
Subject: Re: [GIT PULL] isci merge candidate
From: Jeff Garzik <jeff@garzik.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Milburn <dmilburn@redhat.com>,
        "Ciechanowski, Ed" <ed.ciechanowski@intel.com>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        "Danecki, Jacek" <jacek.danecki@intel.com>,
        "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 8:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> At a minimum It would require a more verbose interface to
> libsas/libata (or new libframe?) to allow us to deliver raw
> unsolicited frames into common protocol handlers.

 ...which is where SAS and SATA have been heading for a while, anyway.
 With chained SAS expander setup you have a network, if an annoying,
manually configured and routed one.  Over that network you deliver
frames of various types.

     Jeff
