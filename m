Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab0JYS1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:27:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47002 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0JYS1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MPDPWd+r7eToNLhnKMOgNrColF2fMDiY1EdkMwcX6JjobGjKzE+Q0RL0t2ykCve9h6
         rhhk+sRiiE6MharFeP+GCgnqson9Yeqbh+XhgIJL1tDOP2McKiMMx38TMLus0kOSxxZd
         Jv1XP5qlkskjtvORWbGfpxS+8nWPI650YyjsQ=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Dowland <jmtd@debian.org>
Subject: Re: [PATCH] toshiba_acpi.c: Add key_entry for a lone FN keypress
Date: Mon, 25 Oct 2010 11:27:35 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-61.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101023221253.GA4829@hathor>
In-Reply-To: <20101023221253.GA4829@hathor>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010251127.37374.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 23, 2010 03:12:53 pm Jon Dowland wrote:
> A lone FN key press on a Toshiba Portégé R700 without another key in
> conjunction results in an ACPI event and a spurious error message on
> the console.
> 
> Add a key entry to map this event to a KEY_UNKNOWN keypress silences
> this message.
> 

Well, if FN key can generate separate events then we should report
KEY_FN, not KEY_UNKNOWN.

Thanks.

-- 
Dmitry
