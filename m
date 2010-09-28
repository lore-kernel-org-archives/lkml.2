Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0I1Gvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:51:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52946 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0I1Gvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HNCe0GOWj/b5H2FBNZv+3fMMgepPTNY7sxXe5TiQ0ErQ7zGhm7kMohr0jckdOiF/3W
         nj02gOm2ubVdo3cHQrY0gxW2OF16p3kMbiyqBBr8O1pevSwcse9eeKu/+jAhMO+abaYY
         rJAZW7LIolqkYX9vgcIuS3r/GyqwHnP/GFam4=
Subject: Re: [PATCH v2] ubifs: avoid kernel error if ubifs superblock read
 fails
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Steffen Sledz <sledz@dresearch.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <1285590026-11629-1-git-send-email-sledz@dresearch.de>
References: <1285577837.16181.14.camel@localhost>
	 <1285590026-11629-1-git-send-email-sledz@dresearch.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:49:48 +0300
Message-ID: <1285656588.2437.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 14:20 +0200, Steffen Sledz wrote:
> * .get_sb is called on mounts with automatic fs detection too, so this
>   function should print an error if it cannot read the superblock in
>   debug mode only
>   (new behaviour conforms the other fs types)
> 
> Signed-off-by: Steffen Sledz <sledz@dresearch.de>

Pushed to ubifs-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

