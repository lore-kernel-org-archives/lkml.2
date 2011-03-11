Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1CKJ5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:57:08 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:59628 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1CKJ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:57:06 -0500
Message-ID: <4D79F1DD.10009@seas.upenn.edu>
Date: Fri, 11 Mar 2011 04:56:45 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH 1/2] hid-ntrig: sysfs nodes for modes
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu> <20110311081843.GE10807@core.coreip.homeip.net>
In-Reply-To: <20110311081843.GE10807@core.coreip.homeip.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-11_02:2011-03-11,2011-03-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1103110011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

User desires aren't exactly my specialty.  I just know the ntrig windows control
panel gives the user that control with cute little radio buttons.

Would it be cleaner to expose the control with an ioctrl or some other mechanism?

I do have user space tools for mode and calibration, but that requires unbinding
the device, and just seems sloppier.  But if this really is inappropriate to add
the sysfs nodes, at least there's still some solution.

Since you brought it up, I am thinking of removing some of the other nodes soon.
 I've learned the physical and logical ranges are already exposed both through
the event nodes and debugfs.  Also, I have better filtering that so far seems
not to need as many parameters so I should be able to remove those nodes as well.

Still learning,
Rafi

On 03/11/11 03:18, Dmitry Torokhov wrote:
> On Fri, Mar 11, 2011 at 02:37:51AM -0500, Rafi Rubin wrote:
>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
>>
>> ---
>>
>> If the code is there, might as well expose a friendly interface to the
>> user.
> 
> The bigger question is should the user care? If we can make the device
> work well without user intervention then we should not really expose
> extra attributes.
> 
> Thanks.
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNefHZAAoJEPILXytRLnK2ud4QAJxzSX+tIrkZawpqvJM69mf3
1P4+E8vCXqsX9usaayGQoa/+CLe2so6frQo3B5nH8ExTOs8+a/Zx1Y9JbNxwqDBJ
aMeWBhO9stqdGjg2hllFeJNV/vuvlU7y6oOW6qme/sKHp0zfisco2nJNvG3yHAQl
tD0TVgiCeEIWkN/AAqoUxGSMtv9pOmkcVfShDVktmOH6pqAsacP29UENZBAKuqQ6
jHtJ2hfQV5NBrKjlHPhcvTiBRrls5SZ+RfRq4hy8MWC8Vj5rjjNLCxmgBeI5Ktqf
ZTRNVvvHClgIbuwHx5LdzPBFNjYv35A87vW8zMHb6/qU57KkeXL1VX6RcONTOS+w
6fWX2AYVMxs/6rU6nXfa/DxgRlPZqyVGP1E8VZ+bl09fJ41WR7xpsOIko93KemUq
DC+kxp9nyfH7bZEpWsr3chEQkbj2aT+1Rjc6312Vsio2Gbzgth8t0WWxEIX69Sp+
hZCzrFPFKiUrlWOdKQG1TkJNh6Z9a1HQLYb67ga2/liyJt9rW6uUfylQDJqN9adj
iGE9xVX6D4+da0CW+hl+0U+EhGX+ZSmvI5IgVdBGsxZnFa/ReP5nJKGFcJmkTtPO
WcZe0zqxORua6xPqA9p2cScbcvCXiHLQtjpLxBQMLlMgghKunSVX9Hl/3OrtOHRZ
r36BGVFmHWBvddvosBqK
=vHok
-----END PGP SIGNATURE-----
