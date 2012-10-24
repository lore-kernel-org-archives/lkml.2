Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab2JXMt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:49:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37187 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab2JXMt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:49:58 -0400
Date: Wed, 24 Oct 2012 13:49:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/mfd/sta2x11-mfd: add regmap support
Message-ID: <20121024124955.GF18814@opensource.wolfsonmicro.com>
References: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com>
 <1350917441-4478-3-git-send-email-ciminaghi@gnudd.com>
 <20121023171837.GE4477@opensource.wolfsonmicro.com>
 <20121024123118.GD26622@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <20121024123118.GD26622@mail.gnudd.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 24, 2012 at 02:31:18PM +0200, Davide Ciminaghi wrote:
> On Tue, Oct 23, 2012 at 06:18:38PM +0100, Mark Brown wrote:

> > This and most of your other readable/writable things look like a
> > framework feature waiting to be written - something data driven which
> > takes a table of register ranges and goes and does the
> > __reg_within_range() check on them.  Seems like it'd be really useful
> > for devices like this.

> I was looking at other drivers with regmap support, and it actually looks
> like this __reg_within_range (or similar) thing is fairly common.

Yes, that's exactly what I'm saying - lots of people need it so it
should get factored out.

> My opinion is that passing function pointers for
> readable/writeable/precious/volatile methods could still be useful when
> registers' features or access properties can change at runtime (for instance a

This is essential for sparse register maps, really.

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh+PsAAoJELSic+t+oim91sMP/3rDbJ5zhAGTb/HDMNZhmV5N
4su4TI5UmKIOhum5ovUo+Qzo+sZXIzobSeLEX9853DOIPC6jsZl65adO++G2NhqX
JYQYSvrOZ/3U7Bl2oBR0P+Ao/7IN55axSCBtXZ8wW9JkffMGZJgLH378pzKbhos8
J8DzhqCYnIjW2tKqsi3lBn1YXyeQ49hnNXIGQpdiJJRhvqP6JG5NtxOmmzxNSKn/
MjeHTb9jfaiCyNhNa/4TCLEJ+00FCxJxQbnL1T8ljuN0QDhZxjOhArkpLENjlI03
8fo1avJl0uraJzfHEUGjeCBSTaosIVqVB9w5JPOHQIQ6GcR4jnnBgMpFSJnamosS
Ca+tpo7TZhAAbUU/5vmCP6+SK2kN0NP86tnL2C0wVPimciZkhTt8fg2OqrV8BZHy
u7f/pxqjzdRHw80dJ4N8c5mGTiwdgRBZX7Toryw++5sw5p8d9OOz9vSPybVeJUtM
cCCbzzOWT2iBTwUcNX1Cf5h7otcQLa8A5Yhn1Mlbl+WOVPBLR8ID9p1IhWjvRo6E
Sewhw3KGk0NFR3bQXB0y92tjvmaD5glfbwAM3BpxS5U4JptJNntuiQ07pN672OY+
MccO9HLpvRF0xjCd4WhzUooD4Czul/8w8CjZi+mpRnQt5JSuH4UWM5pH0Wt8+Fv3
VMRcRVxk0J6deCPHbbSK
=LQ2r
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
