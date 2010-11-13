Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0KMKZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:25:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65327 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0KMKZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I7q4BS0CjrPn1tcQqy6fAbileKdPak1kJ4y5ER7F2VT51k3YVDP5oxLTU5Jrm1szgq
         klwJ++MTufPOol/9RqpAULkB8KdtR7Y8b0PguYq2rY4I2L8kVcMS4Km/RuIKfXpRHhqV
         kTc6ODjD1T7qEQSIeARXNpI3NRnD196joyMQ0=
Subject: Re: [PATCH 1/3] mtd: m25p80: Reinstate error print on unrecognized
 flash
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
References: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 12:25:07 +0200
Message-ID: <1289643907.2218.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 21:11 -0700, Kevin Cernekee wrote:
> Commit b34bc037b26e621e5fc13466767e4da110a7b3d3 removed the
> "unrecognized JEDEC id" error message, causing the probe function to
> silently abort if the flash ID is unrecognized.
> 
> It is desirable to produce diagnostic output in this situation so that
> the user has some idea what went wrong.

Pushed the series to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

