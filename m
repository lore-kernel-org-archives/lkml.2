Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1JVN2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 09:28:54 -0400
Received: from cnxt09253.conexant.com ([198.62.9.253]:24805 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1JVN2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 09:28:53 -0400
X-Greylist: delayed 2178 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 09:28:53 EDT
X-WSS-ID: 0LTGX3J-03-36W-03
X-M-MSG: 
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Namhyung Kim" <namhyung@gmail.com>, "Joe Perches" <joe@perches.com>,
        "Ilia Mirkin" <imirkin@alum.mit.edu>,
        "Youquan Song" <youquan.song@intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 22 Oct 2011 05:50:14 -0700
Subject: RE: [PATCH 00/36] Staging: cx25821: Clean up patch series
Thread-Topic: [PATCH 00/36] Staging: cx25821: Clean up patch series
Thread-Index: AcyQfdvD4egVaRvIR0ChBLFcOjZ7qQAO0j6C
Message-ID: <34B38BE41EDBA046A4AFBB591FA311320506CF35B4@NBMBX01.bbnet.ad>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Oct 2011 12:52:28.0791 (UTC) FILETIME=[74AF8070:01CC90B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Leonid!

  Change in patch #18 is also ok.

Regards,
Palash

________________________________________
From: Leonid V. Fedorenchik [leonidsbox@gmail.com]
Sent: Friday, October 21, 2011 10:43 PM
To: Greg Kroah-Hartman
Cc: Mauro Carvalho Chehab; Namhyung Kim; Palash Bandyopadhyay; Joe Perches; Ilia Mirkin; Youquan Song; Leonid V. Fedorenchik; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
Subject: [PATCH 00/36] Staging: cx25821: Clean up patch series

This patch series fixes some style issues in drivers/staging/cx25821
Mostly I was hoping to improve readability and fix some issues found by
checkpatch.pl script.

There is one question, however, in patch no. 18:
I deleted part of the comment that contradicts to the code and in this
case maybe I should edit the code to match the comment instead. I am not
sure if in this case it makes sense to check if width > 0.

Leonid V. Fedorenchik (36):
      Staging: cx25821: cx25821-alsa.c: Line up comments
      Staging: cx25821: cx25821-alsa.c: Add braces to else clause
      Staging: cx25821: cx25821-alsa.c: Fix indent
      Staging: cx25821: cx25821-alsa.c: Change line endings
      Staging: cx25821: cx25821-audio-upstream.c: Fix indent
      Staging: cx25821: cx25821-audio-upstream.c: Move operators
      Staging: cx25821: cx25821-audio-upstream.c: Change line endings
      Staging: cx25821: cx25821-audio.h: Line up defines
      Staging: cx25821: cx25821-audio.h: Fix multiline defines
      Staging: cx25821: cx25821-cards.c: Fix indent
      Staging: cx25821: cx25821-core.c: Delete empty line
      Staging: cx25821: cx25821-core.c: Fix indent
      Staging: cx25821: cx25821-core.c: Change line endings
      Staging: cx25821: cx25821-i2c.c: Change line endings
      Staging: cx25821: cx25821-medusa-defines.h: Fix typo
      Staging: cx25821: cx25821-medusa-defines.h: Line up defines
      Staging: cx25821: cx25821-medusa-reg.h: Line up defines
      Staging: cx25821: cx25821-medusa-video.c: Fix comment
      Staging: cx25821: cx25821-medusa-video.c: Move operators
      Staging: cx25821: cx25821-medusa-video.c: Change line endings
      Staging: cx25821: cx25821-video-upstream-ch2.c: Line up comments
      Staging: cx25821: cx25821-video-upstream-ch2.c: Fix indent
      Staging: cx25821: cx25821-video-upsstream-ch2.c: Move operators
      Staging: cx25821: cx25821-video-upstream-ch2.c: Remove braces
      Staging: cx25821: cx25821-video-upstream-ch2.c: Change line endings
      Staging: cx25821: cx25821-video-upstream.c: Remove braces
      Staging: cx25821: cx25821-video-upstream.c: Fix indent
      Staging: cx25821: cx25821-video-upstream.c: Change line endings
      Staging: cx25821: cx25821-video.c: Delete empty line
      Staging: cx25821: cx25821-video.c: Change spaces
      Staging: cx25821: cx25821-video.c: Fix assignment
      Staging: cx25821: cx25821-video.c: Fix definitions
      Staging: cx25821: cx25821-video.c: Move operators
      Staging: cx25821: cx25821-video.c: Fix indent
      Staging: cx25821: cx25821-video.c: Change line endings
      Staging: cx25821: cx25821.h: Line up defines

 drivers/staging/cx25821/cx25821-alsa.c             |   73 ++--
 drivers/staging/cx25821/cx25821-audio-upstream.c   |  102 ++--
 drivers/staging/cx25821/cx25821-audio.h            |   39 +-
 drivers/staging/cx25821/cx25821-cards.c            |    2 +-
 drivers/staging/cx25821/cx25821-core.c             |   57 +--
 drivers/staging/cx25821/cx25821-i2c.c              |   10 +-
 drivers/staging/cx25821/cx25821-medusa-defines.h   |    6 +-
 drivers/staging/cx25821/cx25821-medusa-reg.h       |  518 ++++++++++----------
 drivers/staging/cx25821/cx25821-medusa-video.c     |  410 ++++++----------
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  126 ++---
 drivers/staging/cx25821/cx25821-video-upstream.c   |  146 +++----
 drivers/staging/cx25821/cx25821-video.c            |  145 +++---
 drivers/staging/cx25821/cx25821.h                  |    4 +-
 13 files changed, 745 insertions(+), 893 deletions(-)
Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

