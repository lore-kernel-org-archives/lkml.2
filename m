Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0CYUQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:16:11 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:61698 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab0CYUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:16:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eG4phdigQiJz652f5rJOPsqWt9xVP2JyERDfLUyiy61lOYEhBlTE96jttVf7/xIBpX
         kJ7P7/gYcE/hqvgwTnlENb7uMSfJzjsM669T7Y6UBShXDTt22dnMwC5B4J7uVrgrxwDg
         v4IaI/AbtvkAVb01z9I1w+f+ryxhonL8jQS80=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Date: Thu, 25 Mar 2010 21:16:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       bjorn.helgaas@hp.com, airlied@linux.ie
References: <201003252104.24965.maciej.rutecki@gmail.com>
In-Reply-To: <201003252104.24965.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252116.01552.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 25 marca 2010 o 21:04:24 Maciej Rutecki wrote:

> Workaround: setting i915.modeset=1 pci=nocrs OR i915.modeset=0

Update:
I was wrong: setting pci=nocrs  doesn't help.

Regrards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
