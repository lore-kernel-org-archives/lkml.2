Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1EMLgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:36:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62636 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1EMLgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A6BWYDdwPYkPasR2yu9vMk9d1yK36oAGAmXEyK06s8c5+t2AW8rLXOfHpvR12kTgii
         4HrW9Woc4nYp5fEa/0ZKZy3WXHdwE2Ai1gCAWIkbcC6itgo8Uox3l9wLwdQBhWVU7/vP
         2t5LZpvrHL2pClUzHeJZP24legUEOIIX3Bmh4=
MIME-Version: 1.0
In-Reply-To: <20110513070539.GE18783@opensource.wolfsonmicro.com>
References: <1305269646.15846.4.camel@phoenix>
	<20110513070539.GE18783@opensource.wolfsonmicro.com>
Date: Fri, 13 May 2011 20:36:03 +0900
X-Google-Sender-Auth: TvUB1tTe2T4q8VWV0-Ue6WOzAC8
Message-ID: <BANLkTim1DzZQ0hAmwMafYtEZgwi0mGh3fA@mail.gmail.com>
Subject: Re: [PATCH] regulator: Fix memory leak in max8998_pmic_probe failure path
From: Kyungmin Park <kmpark@infradead.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Fri, May 13, 2011 at 4:05 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, May 13, 2011 at 02:54:06PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
