Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1ARA14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:27:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38469 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1ARA1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:27:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:subject:content-type:content-transfer-encoding;
        b=uRa57c2H3/1L/3oZtd2b8M6Vugc/js0W//nuMJV4eizpTp1Fm6fSVFovre/0iBLmLz
         RQAcHkta0eEpBQFWMSIRNp3p+rR6nTfbAEgIIXckCVIk5s8FvB3HE1S3ab07saeFP01+
         xBhF2YP4n8Mj5olrDtLWXW3AgBN3N0l0Rh11Y=
Message-ID: <4D34DE89.4030705@gmail.com>
Date: Mon, 17 Jan 2011 16:27:53 -0800
From: Donna Rigas <donna.rigas@gmail.com>
Reply-To: donna.rigas@dynonavionics.com
Organization: Dynon Avionics
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serial port programming question (newbie)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see lots of serial port programming examples where the
port settings are saved before being changed to the desired settings,
then restored to the original before exiting the program via
tcgetattr and tgsetattr. 

I see one example where someone comments that this is not necessary.

Can someone tell me whether or not it is necessary to save and restore the
old settings and if so, why?
