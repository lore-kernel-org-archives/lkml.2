Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1DWU4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 16:56:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab1DWU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 16:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fYGDdBU9Z7pC7+fRuUrmYGJ+g4A9vJDNoddlNjJnf4RQc1f5Y+50Z+99tH6hUaws8k
         0DcwVHMc9Z8LNLfWFBsZuQpaBDbpbf8ch2MXWO00xmD3bNdzVyj6oKuNUbW5sS7bs2cf
         Ku8RY7SgU5yxClwFuq0BcJ28P3SBW0ajdaINs=
Message-ID: <4DB33CE0.9090509@gmail.com>
Date: Sat, 23 Apr 2011 22:56:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110415 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: =?Big5?B?IkppbW15IENoZW4gKLOvpcO5Riki?= <jimmy.chen@moxa.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [[PATCH 0/2] misc: add support to MOXA V2100 serial io driver
References: <ECB3782BB8F03341905DD923270296115D5A23@mhqms01.moxa.com>
In-Reply-To: <ECB3782BB8F03341905DD923270296115D5A23@mhqms01.moxa.com>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 12:20 PM, Jimmy Chen (³¯¥Ã¹F) wrote:
> moxa_serial_io driver support on MOXA V2100 platform to switch different serial mode, such as rs232/rs422/rs485.

You seem to forgot to send the patches. Anyway, you should route the
patches to the right people (see MAINTAINERS file, TTY LAYER section).

-- 
js
