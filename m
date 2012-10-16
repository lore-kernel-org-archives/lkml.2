Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2JPHdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:33:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25871 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2JPHdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:33:00 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-ad-507d0daa3f4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 14/17] backlight: platform_lcd: fix checkpatch error
Date: Tue, 16 Oct 2012 16:32:58 +0900
Message-id: <007f01cdab70$771d7b00$65587100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAPlxw
Content-language: ko
x-cr-hashedpuzzle: G1qw IUPN Msom RCyk SGEH TUPR Yl/3 YyP8 bONA b4uW fNCY h5wT
 lcGX o1y6 qTyZ
 rYse;4;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0AA==;Sosha1_v1;7;{0A44F51F-7154-4DA3-A7C1-11AB770883BC};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 16 Oct 2012 07:32:52
 GMT;WwBQAEEAVABDAEgAIAAxADQALwAxADcAXQAgAGIAYQBjAGsAbABpAGcAaAB0ADoAIABwAGwAYQB0AGYAbwByAG0AXwBsAGMAZAA6ACAAZgBpAHgAIABjAGgAZQBjAGsAcABhAHQAYwBoACAAZQByAHIAbwByAA==
x-cr-puzzleid: {0A44F51F-7154-4DA3-A7C1-11AB770883BC}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAd1VvLUBBu+nmVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mc92OBb1sFUvfpDQwdrB2MXJySAiYSCxY9IEFwhaTuHBvPVsX
	IxeHkMAiRokdz44zQTizmSQ+bZjCBFLFJqAm8eXLYXYQW0QgQqJ5xizmLkYODmYBH4nNszRB
	wkICthKrZ7wFK+EUsJPY+Pog2AJhAReJZW9+gpWzCKhKHPigDxLmBSrf+XoJK4QtKPFj8j2w
	cmYBLYn1O48zQdjyEpvXvAVrlRBQl3j0VxfiACOJW+vus0KUiEjse/GOEeRiCYEeVonvN7qh
	fjSV+Nl2gHUCo8gsJCtmIVkxC8mKWUhmLWBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HPLPpHYwrmywOMQowMGoxMOb4VwTIMSaWFZcmXuIUYKDWUmE12MiUIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjhvs0dKgJBAemJJanZqakFqEUyWiYNTqoFxvaWdj7z5rk91kbU5V1fGilw4c3rD
	vui3OVaubxcHul/OlndYfFE8psQz+WWBoF7OnBw9txa+8xPdw9hOvV78WPyS8NFpDop8O8oe
	9z2RV9wwszRG98m0E/ZM6bUVEetkd8xp49kU+6RLTjU2485EX3Whny93qTPOPaH06I2uubBE
	T31Jf7kSS3FGoqEWc1FxIgDTjMhvdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error as below:

ERROR: spaces prohibited around that ':' (ctx:WxW)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/platform_lcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index ca4f5d7..74cfca4 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -27,7 +27,7 @@ struct platform_lcd {
 	struct plat_lcd_data	*pdata;
 
 	unsigned int		 power;
-	unsigned int		 suspended : 1;
+	unsigned int		 suspended:1;
 };
 
 static inline struct platform_lcd *to_our_lcd(struct lcd_device *lcd)
-- 
1.7.1


