Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2GFANJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:13:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2GFANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:13:07 -0400
Date: Fri, 6 Jul 2012 02:13:00 +0200
From: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: twofish-avx - remove useless instruction
Message-ID: <20120706001300.GF2091@kronos.redsun>
References: <20120705184358.GE2091@kronos.redsun>
 <20120705234612.GD29301@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705234612.GD29301@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V02:K0:vMFI2fcU+trjcwJ2FhpgiTPIk8ZdfYOFIjfrawgW4vQ
 DuDiTWe2subHH3ONLScJrb7W1OlncHQXx8G95No16gMoQqU7d1
 +qTDq7nipafig9xa9fftQtL/ZHVTK/xUuvi8b1EuM7UsfFEVHZ
 SQ8D9ngdYJT2VBExlPr/RDosPx+gTzbYcw8/BaMF+iT/hVyi50
 Z18hCoxrc+UHzlt3DrBEkt4cA6qxj5I0HBN8deWH0govgFbhUZ
 w2TFj7+Q2zNfvEafm2rBkUsSacFCAwOFYYddLGslYWnFXCD9tE
 VZVyPDI8Fro2qhvhLvU/8nIy4Ar8Lar8RuK1VWJEPqQj+UTG/X
 9B4UE/VJgLSgzYYmtKes=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:46:12PM -0300, Henrique de Moraes Holschuh wrote:
> Is it useless, or is it there to harden against some side-channel
> attack?

When writing this implementation, I first had a different approach with more
data getting read in and I just forgot to delete this instruction in the end.
The instruction didn't have any purpose regarding side-channel attacks. In the
decryption routine the instruction has been correctly deleted in the same
place.
