Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0KZQGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:06:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0KZQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ttwDhvZs/wB1RRTw4nLUpy8ikq2lxHIzMtUkDRjVcxDmvvI7T0AGC96kgjGghwg4dB
         0mBiInSx3aFHZaF5uLsZ/SCXVCD3Y9SWpnhXTBWdy3L2+555aDRVP3xil6i3ZIB/juOH
         Xl0DQzUdzBdrKH2+OwIkUvZ+RdQSU0C2IJnPM=
Subject: Re: [PATCH] fs: jffs2: fix error value sign
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289765320-6071-1-git-send-email-segoon@openwall.com>
References: <1289765320-6071-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 18:05:59 +0200
Message-ID: <1290787559.2552.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 23:08 +0300, Vasiliy Kulikov wrote:
> do_verify_xattr_datum(), do_load_xattr_datum(), load_xattr_datum()
> and verify_xattr_ref() should return negative value on error.
> Sometimes they return EIO that is positive.  Change this to -EIO.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

