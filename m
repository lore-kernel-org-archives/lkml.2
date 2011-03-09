Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1CIOQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:16:43 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56158 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1CIOQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BqkD1R5SC+dz8GxdguYaDOcr71kLk+unACvhRvGirMlHA/OdgStMOzkgn79Y56lozs
         hRv2GeKAfvBUQUfUoCN5xGKRycjTEDp9/RyNjteUiKglntx20iVdTERIiOsTGjezyaIL
         g8cZ1nKw4ltvSRJdFY1ySO+v+4e4BDekWK+AU=
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 16:16:41 +0200
Message-ID: <AANLkTinydE-N2eVgq5aF4m31Asd8sWO2sNgO5tjcGDU6@mail.gmail.com>
Subject: Re: [PATCH] stable: sheevaplug-setup.c fix LED color name and add
 support for second LED This is a patch to the sheevaplug-setup.c file that
 fixes the color name of the existing health LED. That LED gpio 49 is green
 when off and blue when on. The pat
From: saeed bishara <saeed.bishara@gmail.com>
To: Robin Becker <replabrobin@gmail.com>
Cc: kernel@wantstofly.org, nico@fluxnic.net, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        replabrobin <robin@reportlab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 3:27 PM, Robin Becker <replabrobin@gmail.com> wrote:
> From: replabrobin <robin@reportlab.com>
please use short subject for this commit, and move the description
into the commit description section
aslo, I would split this to two patches, one fixes the LED color name,
the second for adding the new LED.

>  static unsigned int sheevaplug_mpp_config[] __initdata = {
>        MPP29_GPIO,     /* USB Power Enable */
> -       MPP49_GPIO,     /* LED */
> +       MPP46_GPIO,     /* RED LED */
> +       MPP49_GPIO,     /* BLUE LED */
>        0
>  };
>
>  static unsigned int sheeva_esata_mpp_config[] __initdata = {
>        MPP29_GPIO,     /* USB Power Enable */
>        MPP44_GPIO,     /* SD Write Protect */
> +       MPP46_GPIO,     /* RED LED */
>        MPP47_GPIO,     /* SD Card Detect */
>        MPP49_GPIO,     /* LED Green */
please fix the comment as well
