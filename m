Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1GSBXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:23:54 -0400
Received: from ozlabs.org ([203.10.76.45]:45462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1GSBXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:23:53 -0400
Date: Tue, 19 Jul 2011 11:23:51 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
Message-ID: <20110719012351.GL20597@ozlabs.org>
Mail-Followup-To: Ayman El-Khashab <ayman@elkhashab.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
 <1310748027-31956-1-git-send-email-aymane@elkhashab.com>
 <20110718040115.GK20597@ozlabs.org>
 <20110718133101.GB26701@crust.elkhashab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110718133101.GB26701@crust.elkhashab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 08:31:01AM -0500, Ayman El-Khashab wrote:

> Yes, but I think that is correct for it to be "1".  The data
> sheets for these parts that I checked had bit 1 marked as
> reserved.  Only OMR1MSKL and OMR3MSKL had extra definitions
> such as the _IO and _UOT.  The parts I checked which were
> the sheets for the EX and SX (which cover another 6 or 7
> parts) all had it with just a single bit defined on that
> register.

Ahh okay.  I kind of think that this may need to be a seperate change.  At the
very least it needs to be explicitly mentioned in the change log.

Yours Tony
