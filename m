Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0F1TIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:08:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61910 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0F1TIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m1LOhiUyRE99iqRA5fd8BsgSKOiO3/ZJIZKf8mngPzB/fN66FtSUNsohkp7c19kQct
         ZWLQ3A7Ly12L0hA6dR4s6WySgRNjzIqTgr7q4KXRQ/4wRxsyaV/LJuP1HQwl5nIXligy
         BahE9H9kZ9lVXe3rCqzg8SFRkBB0ciAsXZthg=
Message-ID: <4C28F333.7040304@gmail.com>
Date: Mon, 28 Jun 2010 12:08:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com>
In-Reply-To: <7214.1277729293@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no need to have extra cc's on this, so I took some people
off since they dont pertain to this area.

Justin P. Mattock
