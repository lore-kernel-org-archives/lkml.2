Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2EEUIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 16:08:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61333 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2EEUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 16:08:03 -0400
Message-ID: <4FA5889E.2030008@gmail.com>
Date: Sat, 05 May 2012 13:07:58 -0700
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        chatty@enac.fr, benjamin.tissoires@gmail.com, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: MT - Include win8 support
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 08:08 AM, Henrik Rydberg wrote:
> The newly released HID protocol for win8 input devices is capable of
> transmitting the same information found in the Apple HID and Linux MT
> protocols. In addition, it includes an extension useful for touch
> alignment. This patch completes the MT protocol with the
> ABS_MT_APPROACH_X/Y events, and documents how to map win8 devices.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi all,
> 
> In response to the win8 HID protocol and Benjamin's work on this, here
> is a first draft of the needed extension to the MT protocol. I am
> cc:ing the usual suspects, as this will affect userland. Comments and
> criticism expected. :-)
> 
> Cheers,
> Henrik
> 
>  Documentation/input/multi-touch-protocol.txt |   35 +++++++++++++++++++++++++-
>  include/linux/input.h                        |    4 ++-
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index 543101c..504ca6d 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt

[snip]

> @@ -252,6 +254,9 @@ can distinguish between the two axis, but not (uniquely) any values in
>  between. In such cases, the range of ABS_MT_ORIENTATION should be [0, 1]
>  [4].
>  
> +For devices capable of 360 degree orientation, the reported orientation
> +should be twice the given range.

I don't understand what this means. Can you elaborate?

-- Chase
