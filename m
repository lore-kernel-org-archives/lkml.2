Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2LXQey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:34:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45005 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab2LXQev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:34:51 -0500
Date: Mon, 24 Dec 2012 16:34:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regulator: core: Allow specify apply_[reg|bit] for
 regmap based voltage_sel operations
Message-ID: <20121224163449.GY30837@opensource.wolfsonmicro.com>
References: <1355794210.5681.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HJ7DkX9BXQhna2ov"
Content-Disposition: inline
In-Reply-To: <1355794210.5681.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HJ7DkX9BXQhna2ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 18, 2012 at 09:30:10AM +0800, Axel Lin wrote:
> Some DVM regulators needs to update apply_bit after setting vsel_reg to
> initiate voltage change on the output.  This patch adds apply_reg and

Applied all except patch 2 (where you've done a new version, I'll wait
for Haojian to ack though) - thanks!

--HJ7DkX9BXQhna2ov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IQfAAoJELSic+t+oim9AAkP/29pByzrVDUDTT4OPSeiaVDI
ijFNDiYGF3UUnD9XiktR/Hce8e7gp1XJgOKHm+RWnGF4bd9TNXaXhFwhugVWFPzN
iwZ8ukqQIbnz91jRA3/qEUCnV5pqxztztKR/n/7OR1E8BxpuVtXNg0yDhSfiuf9z
5+os6R68nkpn/taCcjQLrmXcRZM47WJEQUbr65LRLXCnkOK5NMXU7Yfh8RCXOP68
enmV9pxDhTBpNTOPOal68fonSev5sahoWeJ2NHx6UDJwIgbcCcK0bXP0dSxonLjl
/iHP9rbXdVEOlBeJiY4B8mIOTXuexzddTH7niRH59l9l85/tL95Lm/bUptqcU2lB
OpFuKbLSRDSc7aPfAnwd54o2W5iEzot1RzTXcBT/uH2tn2E/SxSM3AubbRUWb5Q+
z3S7Xy9xKPhwCJwuZlSqsfCiiW+klE7VSw6q9jOXuOVd7aR3zF/cRMXPpUwJMmn0
E0cxn29AtvjNT4O8QyqP1f5uKmsR0Sy9PdMfbU+tnVKsEaG2ytKJNUvJObRGtjpb
HJFy0kL45T+BDBUqIpQNEOJHrCHbRekZX7uwypaZlqj8nW4H+Dkp7L4tpMdZmJ5V
0Vb9Tb9jDcRw7PWsnH6G9N1M5/dCPSDzZgcbrFtVWkm++7s0UDPa9ilrfbthsB40
guizc6bW9XC1BOyA/CaJ
=j6en
-----END PGP SIGNATURE-----

--HJ7DkX9BXQhna2ov--
