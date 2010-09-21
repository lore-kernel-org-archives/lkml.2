Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0IUWTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:19:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56380 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0IUWTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:19:20 -0400
Message-ID: <b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
In-Reply-To: <20100921214847.GF26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
    <20100921214847.GF26290@redhat.com>
Date: Wed, 22 Sep 2010 00:19:16 +0200
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic
 constants
From: "Andi Kleen" <andi@firstfloor.org>
To: "Don Zickus" <dzickus@redhat.com>
Cc: "Huang Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Andi Kleen" <andi@firstfloor.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> I guess adding either another knob to override the hardware error option
> or tying it in with the panic_on_unknown_error option might make me more
> comfortable.  That way enterprise customers can always just enable it by
> default and desktop users (for now) could have it off.

Anything that needs explicit enabling is a bad idea, that
would lead to a lot of users running in "corrupt my data" mode.

The code currently uses the presence of a HEST error table
to detect a server. HEST should be only available on servers.

On servers at least panic should be default.

-Andi


