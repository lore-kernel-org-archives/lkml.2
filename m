Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0GRIoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:44:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36116 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0GRIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p2nLvDEm20Jh5Sf+ZDtu7d8ifzs7JYfhi3ByU35MWq55iAXN67698cXCwDD3m1/zT9
         4m/XknxfqIDzPPw3af6bIImD3Kp84IxZWolvq5c0IkLdqKyuLGprWvST03vJMq86iWTT
         0GmJivO3wMiEk7UqcQuqxLIswic5PcA7JgwMQ=
Subject: Re: [PATCH] s3c nand: parsing commad-line partitions prior to
 set->partitions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Conke Hu <conke@maxwit.com>
Cc: support@simtec.co.uk, linux@simtec.co.uk, ben-linux@fluff.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1278996990-4380-1-git-send-email-conke@maxwit.com>
References: <1278996990-4380-1-git-send-email-conke@maxwit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 11:44:08 +0300
Message-Id: <1279442648.16247.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 12:56 +0800, Conke Hu wrote:
> Current driver prevents command-line partitions from being parsed when built-in 
> partitions are defined in s3c2410_nand_set object, but it is not desirable in some 
> cases. This patch tries to parse commad-line partitions prior to the built-in.
> 
> Signed-off-by: Conke Hu <conke@maxwit.com>

Pushed to l2-mtd-2.6.git / master, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

