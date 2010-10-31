Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0JaHrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:47:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0JaHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IUzkT2YsoFfH/NyNcBHCS9iWNrCm1yTuCJkdVN33Tb7yFuGWt8YxAcbXGbHKUECdRj
         wni0AOzJgbg07cUYLH9Hknyj5ZkkPkHzpnrejPQnWG14n4+6Bzy2YI9JEW92754KKuOD
         6K1HJmkKtwB6bm0nKL6GMZWg1kWtBFq9rcp1w=
MIME-Version: 1.0
In-Reply-To: <a4a2512bcf19341d19db73534412250e@localhost>
References: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
	<a4a2512bcf19341d19db73534412250e@localhost>
Date: Sun, 31 Oct 2010 00:47:19 -0700
Message-ID: <AANLkTi=CqWzxN7e6S6kUDqNgCodEt08caTAqW5em0XOd@mail.gmail.com>
Subject: Re: [PATCH 2/3] mtd: m25p80: Add support for Macronix MX256L25635E
From: Kevin Cernekee <cernekee@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected subject line:

[PATCH 2/3] mtd: m25p80: Add support for Macronix MX25L25635E

"MX256L25635E" is incorrect.
