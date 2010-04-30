Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab0D3Sgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:36:38 -0400
Received: from usul.saidi.cx ([204.11.33.34]:47248 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753890Ab0D3SgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:36:17 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: =?UTF-8?Q?acpi=5Fidle=3A=20Very=20idle=20Core=20i=37=20machine=20neve?=
 =?UTF-8?Q?r=20enters=20C=33?=
MIME-Version: 1.0
Date: Fri, 30 Apr 2010 14:35:02 -0400
From: Philip Langdale <philipl@overt.org>
Cc: Len Brown <lenb@kernel.org>, Jeff Garrett <jeff@jgarrett.org>,
       Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
In-Reply-To: <20100430174447.GA14889@srcf.ucam.org>
References: <20100126084740.GA5265@jgarrett.org> <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org> <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain> <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org>
Message-ID: <d7f2dd35a4361e5156079278543769a0@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 30 Apr 2010 18:44:47 +0100, Matthew Garrett <mjg59@srcf.ucam.org>
wrote:
> On Fri, Apr 30, 2010 at 12:25:44PM -0400, Len Brown wrote:
> 
>> I am hopeful that the "right thin to do" is to not look at bm-status
>> and that perhaps there is a bug where we are looking at it
>> "by mistake".
> 
> https://patchwork.kernel.org/patch/58962/ - it seems to be a win.

Indeed. This patch does solve the C6 problem. I'm not in a position to
speak about whether there's any undesirable I/O latency, but it
passes the basic sanity check.

I have filed https://bugzilla.kernel.org/show_bug.cgi?id=15886 with
my acpi dump - assuming that's still useful.

--phil
