Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1EWFV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:21:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59242 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1EWFVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DeSZyECDvFBhaLH2rVo+81JucG/OvQz1LA4g0pK+zADH+9uDGbOQrvofxTlsCRhu7U
         oCNrsoTsOrlF2isXI2IlM3gmqwjvBp4yUwICxE/ogVS93NzQ4DBf9D/7b6GjGna0Rj+e
         MAjvuY6apbIkf5znztax6EZdgXudj5oSOBEIs=
Subject: Re: linux-next: build failure after merge of the final tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110523145646.62152db5.sfr@canb.auug.org.au>
References: <20110523145646.62152db5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 08:17:14 +0300
Message-ID: <1306127834.2630.154.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 14:56 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:

Hi,

should be fixed now, thanks and apologies for the breakage.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

