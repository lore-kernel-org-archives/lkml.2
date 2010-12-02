Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab0LBOtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:49:42 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41116 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757793Ab0LBOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:49:41 -0500
X-Sasl-enc: LkElTBBU3D7C2ZpXA9lsQKwcw3GTtTzJ/IRyfrKf0BiU 1291301380
Date: Thu, 2 Dec 2010 12:49:38 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: low overhead packet capturing on linux
Message-ID: <20101202144937.GA5731@khazad-dum.debian.net>
References: <201011301728.05197.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011301728.05197.thomas@fjellstrom.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Thomas Fjellstrom wrote:
> So what I'm looking for is a very low overhead way to capture packets. I've 
> come up with a few ideas, some of which I have no idea if they'd even work.

Out-of-tree PF_RING :-(

I really wish someone would tack this problem in a way suitable for
inclusion on mainline, now that we have very good generic backend
infrastructure for such stuff (such as high-speed ring buffers).

AFAIK, what we have right now simply can't cope well with wirespeed taps
(or implement sflow-style taps with low overhead) on very fast links.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
