Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2LDQfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:35:45 -0500
Received: from mail.tpi.com ([70.99.223.143]:4667 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab2LDQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:35:44 -0500
X-Greylist: delayed 1779 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2012 11:35:44 EST
Message-ID: <50BE1F6B.8030909@canonical.com>
Date: Tue, 04 Dec 2012 09:06:03 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Tim Gardner <rtg.canonical@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL] linux-firmware: cx23885: update to Version 2.06.139
References: <50BCEBCB.4080303@gmail.com> <1354597630.17107.42.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1354597630.17107.42.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/03/2012 10:07 PM, Ben Hutchings wrote:
> On Mon, 2012-12-03 at 11:13 -0700, Tim Gardner wrote:
>> Ben - what is your policy on extracting firmware from Windows 
>> drivers?
> 
<snip>
> 
> I'm not sure how you can say they are the same files, as you're 
> proposing to change the contents.  The copyright on the current 
> files belongs to the chipset vendor, Conexant, and Hauppuage 
> *presumably* used firmware supplied by Conexant, but either of
> them might have chosen a different licence for the versions in this
> driver package.
> 

I guess that is the root of the issue. In light of the licensing
uncertainty I think you should just drop this pull request.

>> ----------------------------------------------------------------
>>  Tim Gardner (1): cx23885: update to Version 2.06.139
>> 
>> v4l-cx23885-avcore-01.fw |  Bin 16382 -> 16382 bytes 
>> v4l-cx23885-enc.fw       |  Bin 16382 -> 376836 bytes 2 files 
>> changed, 0 insertions(+), 0 deletions(-)
> 
> How odd, these two files are currently identical to each other...
> 
> Ben.
> 

Indeed they are. The comment in the bug report [0] indicates that
those files should not be identical.

[0]
https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/569615/comments/4

rtg
- -- 
Tim Gardner tim.gardner@canonical.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJQvh9lAAoJED12yEX6FEfKYD8P/ih3NovJAZqndS8ljG/X7Pcw
7pgQNM0WWiiwjNxcxQK+s+w/XV1QJGztLgXDduUEb3jD8nNH2qvAGXVgBKWZNSqQ
alSF6yqvRUq8G2h6CJc6/T9MVmhaYm1GkgXRVFViLFyvjh9wc6xxD/O5SA3Fr0Q2
J0Js4/vExIoFd8ps+9cB4+AzDqWmiEGk5FBseNLwO2zrDyzziO7tXH6K3W34n1EW
ztVOnkFbrvVBuf/QOQFBbt06ziKINwPsyZkCyUHCWs7WXmWLLH1rvrH2CSGvQkXY
S5fk/H1j5LRCellURpAbs9x50OWdShOQs05mSpd4eZmD1lvFqjMCCYWHn4AR2fvk
yXi71uendvfVFfFHlN3kWHnCLICLJUa8urMRDSts3XRUFXZDijeJVWpJZJXK5m+W
40NIkDOQVvVHWxL+W1bCiM36uE0f+9klsqfs0nWB1xERol9peaoqJhoW1VyzHEmK
7QSt1+nezFuURfaSktG2W/WsRZuo6RI9ElOWrOVGrmnA3PoYun8KlanGyGiS+ezu
/b2l/yxPAlanHXcAtpCcV7h+sLL9k7z5rIUZDuseHazAw14jATGu7LLpac7nvPCB
cuYvKUeVOSPi/fkC5A+pSWMDznjr92bgTf71tlzzGTNDIq/MQCwpotxJUfOXr3Oh
5dZzEgczjDDdYMniC6rl
=egal
-----END PGP SIGNATURE-----
