Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1BVUBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:01:35 -0500
Received: from smtp-out.google.com ([74.125.121.67]:48979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1BVUBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:01:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eI4zUFwnPWKRu0vqVMfG9Alf6VZJezQOwD1rb1+uujYQ3nw/g1IFzTehhDL+T2YJXD
         7uTbl98NcPxqqYLxWpZg==
MIME-Version: 1.0
In-Reply-To: <1298250861-27094-1-git-send-email-ccross@android.com>
References: <AANLkTim0X=gUwYJmR+EAYjGamiJb7tgiVEjwqCEF0-L0@mail.gmail.com>
	<1298250861-27094-1-git-send-email-ccross@android.com>
Date: Tue, 22 Feb 2011 11:59:49 -0800
X-Google-Sender-Auth: D_THm6judwdFKDeV9_lB-dSGdoM
Message-ID: <AANLkTim1obQs6m7w4m+iCdZKfv6W=frFAcN_kTmi9=vg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Add i2c support
From: Colin Cross <ccross@android.com>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        swarren@nvidia.com, patches@opensource.wolfsonmicro.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 5:14 PM, Colin Cross <ccross@android.com> wrote:
> Adds I2C bus driver for nVidia Tegra SoCs.  Tegra includes 4 I2C
> controllers, one of which is inside the Dynamic Voltage Controller
> and has a slightly different register map.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Ping?  Can this go in 2.6.39?
