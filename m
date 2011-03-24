Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1CXQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:52:56 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:38071 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1CXQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:52:54 -0400
Message-ID: <4D8B76C9.7000601@seas.upenn.edu>
Date: Thu, 24 Mar 2011 12:52:25 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, chatty@enac.fr,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/2] hid-ntrig: calibration
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu> <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu> <20110321171550.GA4602@polaris.bitmath.org> <alpine.LNX.2.00.1103241531130.19969@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1103241531130.19969@pobox.suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-24_02:2011-03-23,2011-03-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1103240074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/24/11 10:32, Jiri Kosina wrote:
> On Mon, 21 Mar 2011, Henrik Rydberg wrote:
> 
>>> Adding a function to tell the device to run its calibration routine.
>>> A number written to the sysfs specifies the duration of the calibration
>>> in milliseconds
>>>
>>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
>>> ---
>>
>> This is great functionality, and from what it seems, it works. However, 
>> the poking at the usb layer makes me wonder if there is another way... 
>> Jiri? Dmitry? Awaiting answers from someone more knowledgeable, please 
>> find some comments inline.
> 
> Actually, let me put it another way -- is there any reason not to have 
> this as a functionality provided by HID core code (with driver registering 
> callbacks if they want to provide calibration functionality)?
> 
> Thanks,
> 

I thought Henrik was asking about an alternative to the raw usb calls, something
like usbhid_submit_report that would satisfy the needs of this calibration routine.


As for a standard hid calibration interface, I like the idea.

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNi3bIAAoJEPILXytRLnK2HO4QAJQtrlG2PB4mERWQ5gGkoJTT
qYoQiek1RJylFb/wJlzVajMtjQ+kFc98N3faSmIvbrsXwYZfEYZQxlnS/463EYTw
vnYgSFTqj7+mSwrQMX4civJTZJPfbLGJD1wvzBBq8cAhPonedn2z3a8gU30AdPc3
Dc/Ht+dHgOomzdkfjn77GTGYyiGDZwl0mYPuh6nhOBjhOmUDErRg+4yZQ1/wfaJr
2jEty0hEXwwkD1iqgDPmIqiEIZ7r5RkGCOWUsi+0rMeIiobaUxk281c0aZ295BFT
PhGbiqzkASp+a7TpVpdnHFCofmCSinb00gpbVbeqtuUsauNuUgVVij/lPe0vxTNB
ivW5V3MYgceDCDkAR+p3nsu3lvYv6cWqbxFQ5pzUIkxsnEfUowpjWLoSQl3Fmym0
IbKYs4ueAgI3G7gw+xQfjnJX53DmAbKoXoQAesSEwzAXCAz1BSZih2ORPTGM68Pd
eDLk729/6RAFZVmnwgNlEfx68vaxmhrHK0GDod2k/V/TRsSBG42I15G8p7Xu359m
cQyNUraMDFfHvC71Y6ZIL3tK0h2LXjsvd1Z17HzAROFWm2tNSSjg/xaVJ0ftDot3
cIM86Na/ysGwdKRB1xdElPBf8rb+vjVPDcv4v3PJTd9GbgN6MoRl1RWtv+XwnW/A
VzPpDqxYbAW9hewHbzSW
=KW05
-----END PGP SIGNATURE-----
