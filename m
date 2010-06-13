Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0FMRVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 13:21:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38633 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0FMRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 13:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FcrVUPNzl9jL32OUWl58HycCjX2bGL6WhC7dYYso1ZIf9LAzqWxOpARS3INskGtNDh
         IO58Oa9RfrDJWX+a3on0/JsU/WsZTvYfYVOiOMQTuwsskmSxKwT+8H3Y98deV1EfmD3M
         +3n3HB58BGot2ThuIK4g0Nh9tEkJoZDRnASSM=
Message-ID: <4C151387.5040209@gmail.com>
Date: Sun, 13 Jun 2010 19:21:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.35-rc{12} regression: inactive console corrupted
References: <20100612103321.GA1458@ucw.cz>
In-Reply-To: <20100612103321.GA1458@ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2010 12:33 PM, Pavel Machek wrote:
> When something happens on inactive  console (using fbcon), display is
> corrupted -- lines at end of screen are not erased properly.
> 
> I see it on zaurus, but I suspect problem is generic.

Hi,

does revert of 962400e8f or update to -rc3 help?

-- 
js
