Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab1KHPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:16:10 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:41407 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1KHPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:16:08 -0500
Message-ID: <4EB9477E.8070002@atmel.com>
Date: Tue, 08 Nov 2011 16:15:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Nikolaus Voss <n.voss@weinmann.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org, rmallon@gmail.com
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
References: <cover.1320753142.git.n.voss@weinmann.de> <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de> <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/08/2011 03:41 PM, Felipe Balbi :

>> +	if (cpu_is_at91rm9200()) {			/* AT91RM9200 Errata #22 */
> 
> I don't think you should be using cpu_is_* on drivers.

It is a common pattern in at91 drivers and has worked for ages.
Do you think it is related to the need to be able to compile the
driver for any SoC in the case of multi-SoC zImage support?

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOuUd1AAoJEAf03oE53VmQs9UH/i+pKZlIN7lNb+sHvqHJhiUK
zqvPObtSo2Y78dODM4Qf/WrJP/jBW4FUAx60kBlEBzWAD2aef1D078POAOVhcVdH
Gj76Z+O5tF9H9YPcn/9HGyA42kL3NZu43ibywsvbUmX1O2LbtmX49bGOjArYSyXQ
sN4F8+QJnkMQfmMNjYgG0WfhMyWnp15W4QWq+frk2Kq0nXjiuozqr9goq8/LVRZc
aSToJUUJqsfk/bEGBAF6RmNxRIu2AMNpKQZS9a1gOZA/mAfSZrT9zQE6EZVXJDVr
VVck4KlhHBR3JU6AEh0CtoRgfZxsZyzS2RNUDyF7dq+8VsNiNpajSL8S2ILanZc=
=iqlm
-----END PGP SIGNATURE-----
