Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1ARAll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:41:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65282 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1ARAlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=T3V5dPyeV9iuzOIUZ0fMXU+PBDR7tEwKa88jF9yO/ShXZ81M0nagpDcavkdqkjzmJr
         nYV3agAk+THwxdAS1RSnjE6XxLV0Whkzqogdo5WTCYyeI6WQty1jqSwRWc1MREJyrHxI
         RYFgBbf8srU5GxWF7MXDPv7jztNNL7iGyxj7M=
Message-ID: <4D34E1C2.1000602@gmail.com>
Date: Mon, 17 Jan 2011 16:41:38 -0800
From: Donna Rigas <donna.rigas@gmail.com>
Reply-To: donna.rigas@dynonavionics.com
Organization: Dynon Avionics
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serial port programming second question (newbie)
References: <4D34DE89.4030705@gmail.com>
In-Reply-To: <4D34DE89.4030705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, if your call to tcsetattr fails, or if  the ioctl call to
set the baud rate fails, does it matter if you restore the serial
port settings or not?
>

