Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0IERxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 13:53:08 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:48536 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752024Ab0IERxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 13:53:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kMtKG5dwBpLsTHpgT+fORovkkK/gNr3Bp9g3CLJ62oPDkpTmCY3su1IL55tgFTEFHmgF2O0gnMW1tIp+agARB0LdMjarfUoNkq+/dda0XZ6E1j2HifUF0PhHauk5WL1F;
Date: Sun, 5 Sep 2010 10:53:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Pekka Enberg <penberg@kernel.org>, Sven Joachim <svenjoac@gmx.de>,
        Hugh Dickins <hughd@google.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Message-ID: <20100905105303.43d3a777@jbarnes-desktop>
In-Reply-To: <89k83a$9i7dn6@azsmga001.ch.intel.com>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<4C83C124.8050408@kernel.org>
	<8u3s8d$jg1fmi@orsmga001.jf.intel.com>
	<AANLkTikjBztwp5rcGKGWc_6DLkFu5CTXAbePTbjEfyML@mail.gmail.com>
	<89k83a$9i7dn6@azsmga001.ch.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 18:21:10 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:
> I've lost track of the current status for releasing the documentation for
> gen2/3. As always, it should be ready real soon now. 

Last I heard, the hw guys wanted to do a scrub but wouldn't be able to
allocate time for that until Nov. or so.  We may be able to get the
display section out sooner though, I'll check.

-- 
Jesse Barnes, Intel Open Source Technology Center
