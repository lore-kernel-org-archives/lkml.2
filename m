Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab2C2LIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:08:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52193 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757797Ab2C2LIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:08:42 -0400
Date: Thu, 29 Mar 2012 12:08:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Michael Bohan <mbohan@codeaurora.org>, lrg@ti.com,
        LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120329110840.GF3668@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
 <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
 <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
 <20120328193341.GD3232@opensource.wolfsonmicro.com>
 <4F73A798.6030607@codeaurora.org>
 <4F73E895.6000207@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Content-Disposition: inline
In-Reply-To: <4F73E895.6000207@ti.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Mfx4RzfBqgnTE/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 10:14:05AM +0530, Rajendra Nayak wrote:
> On Thursday 29 March 2012 05:36 AM, Michael Bohan wrote:
> >Put simply, whose responsibility is it to assign the
> >regulator_desc->supply_name pointer before registering a regulator
> >device added from Device Tree?

> The drivers, and its expected to know, and not lookup something from
> the DT node to figure out what regulator_desc->supply_name should
> be.

Also note that this stuff is essentially unrelated to device tree,
exactly the same mechanism should be used by all drivers it's just that
we happened to improve the framework when adding device tree support.

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEKvAAoJEBus8iNuMP3dzV4P/3EYfMDQUmhIuTjvQwhPAZHz
lLFEoTWfmXUBHpUKilyI1UMCEbYOh+EIAWM/rFWc2YU2rdcctwdi9y7GtbPmZtL6
WLvEFZlDflP4xuNjRXHokXKKnOhe6NRdmlyZDCmmR8aGATU7lgBObSHoMzbe0sOi
klI07cQ+E7n3GlDjW+V2gPbqGxGvW66+1buBY/o4d0EkC5KhCmRHMavZDOKCDs1D
Cod5awwTQjce550YbjYNR4BSbuV7MZdFIC/sFcVR969J9hRLCeaK+CbY+BF7M2WL
Qkn6inYUxUC3/Yhk4F/qP7sX2kbsDDwWbuh4TWAWLdHEBN/k7TxZ4JucOHWLeroC
5LxMARlPXnO/BByRs+W1AUCaV246BcX7HGIwtT3VUNUKB+CunbwkV81Y4rYCTGm6
xRoWw6eeS/2hwzfwnj+hxWsiR26wzCLKKCAPds1lWeSaHbXJz6dlNHlKs0JyCt76
h1tvCeOv+ss9JsOhRDe1FZsYwxGArmy/xXkUJP4t94AO1p1CISD5G0p+GfaQe8/T
MbXOXZFeybtRoPs04yViWcl9knWWw50DeNief398ct3oCt3JZPN5rhMaA1YsPrM7
cRD0L+0ekeuKJd/jRBCy7Uh6bHnXjYm6R4uBNUT1XVfDxxzXO7JDibTfMuXU5gl7
y5O74jjXyVcGfsBOEmy9
=VDgL
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
