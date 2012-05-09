Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2EIIiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:38:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37095 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab2EIIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:38:07 -0400
Date: Wed, 9 May 2012 09:22:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anbu Manikandan <canbumanikandan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kmemleak feature
Message-ID: <20120509082248.GA11099@arm.com>
References: <CAAGB47OajENL-g-CvdAgp1k2XKU4dOWbHz=mDy79mPOvi-eEmQ@mail.gmail.com>
 <CAAGB47PiZ0cveWvObEjS8OPB++M3s1dENybnjoxyhQ8K_T4SpA@mail.gmail.com>
 <CAAGB47PmB8o=mrnSoU1jYt_ecjH2WBLEzGRFqZWhWZXWQkTHaA@mail.gmail.com>
 <CAAGB47PpTx9-eFz6ppbCYshA5yp293Tm1X-cAaBkZ+xX05_UUg@mail.gmail.com>
 <CAAGB47N3oPkK1WhwzB7q4_6rvzKbnx3Ugwdr+aUuwTqiNX2oog@mail.gmail.com>
 <alpine.LFD.2.02.1205090925420.1879@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205090925420.1879@tux.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 07:27:28AM +0100, Pekka Enberg wrote:
> On Tue, 8 May 2012, Anbu Manikandan wrote:
> > I am very much interested in learning about kmemleak feature in linux
> > 3.0-RT kernel.
> > I have already read the kmemleak document (Documentation/kmemleak.txt)
> > provided in the kernel source.
> > 
> > Furthermore, I would like to understand the internal functionality of
> > kmemleak source code.
> > Could you please share some documents, links or presentations to
> > understand the kmemleak internal functionality?
> 
> Catalin is the main author of kmemleak. I'm not aware of such 
> presentations.

There was one last year at LinuxCon in Prague:

https://events.linuxfoundation.org/images/stories/pdf/lceu11_marinas.pdf

-- 
Catalin
