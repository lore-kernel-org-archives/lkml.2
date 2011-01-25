Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1AYPXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:23:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39101 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AYPXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:23:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cW8lbT51oUVuMt+8QQABaO5hRHEX+Vyox/CCeoKkUezicIFKlFXi9TypROfmd7hFVI
         FOYXwoABVPxJw1YYcOGfDKPFsfoXbO8ugi4k18RgbIlDybSNXsuiy0Qoad1pDCMq1oTp
         OmIBnTRmFsIicBZn+Fm81md4VQX7m5F/ylg3w=
MIME-Version: 1.0
In-Reply-To: <1295960706-15667-10-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
	<1295960706-15667-10-git-send-email-marek.belisko@open-nandra.com>
Date: Tue, 25 Jan 2011 17:23:02 +0200
Message-ID: <AANLkTikD=Ke22mVhtD9NmKQS-JpXAJz5X1yeJrV2HGDy@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] staging: ft1000: Fix coding style in
 put_request_value() function.
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry, but per-function split is ridiculous.
