Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981Ab2CVQ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:56:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39412 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2CVQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:56:28 -0400
Message-ID: <4F6B59B9.90902@suse.cz>
Date: Thu, 22 Mar 2012 17:56:25 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com> <4F6B51C9.6010904@suse.cz> <4F6B5902.1080607@zytor.com>
In-Reply-To: <4F6B5902.1080607@zytor.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 05:53 PM, H. Peter Anvin wrote:
> having declarators
> and definitions be different is just asking for trouble.

Yes, agreed.

-- js suse labs

