Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0KGU7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:59:14 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:41927 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0KGU7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:59:13 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 15:59:13 EST
Message-ID: <4CD70FC0.6060503@seas.upenn.edu>
Date: Sun, 07 Nov 2010 15:44:48 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1289161108-32309-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-07_06:2010-11-05,2010-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1011070114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 03:18 PM, Henrik Rydberg wrote:
 > Some kernel drivers demand the use of contact tracking for proper
 > filtering and pointer emulation. With one exception, these drivers
 > are limited to a maximum of four concurrent contacts. This patch adds
 > a simple matcher for up to four contacts, with these notable properties:

Tracking in the ntrig driver needs to support a minimum of 6 fingers.  I have 
also seen press releases claiming 10+ eventually.  I don't know if those devices 
will support tracking in the hardware/firmware.

Rafi
