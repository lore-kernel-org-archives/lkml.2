Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0KVM5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:57:13 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34117 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0KVM5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wY5YlRGLEIlT1DSBSj4JD1Ak2fct/tYZPfEPnMkyba8qdthlQJ/hEw2NB5d6BfPH7/
         sxu9K6HG3nWgDocrdy6Wbum9HFnUlROpZzERsi5A+0zfohJhefSj925Cdec4WHj3RouY
         WyxqKmYCe17Ny9h2IeYZriBrG6HWZXxQMoMe4=
MIME-Version: 1.0
Date: Mon, 22 Nov 2010 13:57:11 +0100
Message-ID: <AANLkTimTNBZ+H6h=yOX4d7xaTRAyMLuTCTiQMN_aR7xw@mail.gmail.com>
Subject: drivers/usb/gadget/rndis.c - creates proc file with 660 permission
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave

drivers/usb/gadget/rndis.c:1160
rndis_connect_state[i] = proc_create_data(name, 0660, NULL,

I know that 660 is not my favourite number - the number of the beast,
but it seems to me that it should be 600 - like in other cases.

-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!
