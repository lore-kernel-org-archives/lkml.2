Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1BJTsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:48:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47221 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1BJTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FTeWSAim0yGOQ4VQJF1U5lXLZfvXwSH1KZD2MynIhmDD5uvseJPOC2kfQS81+xEII+
         QWLnjWlpjWH/9u1Jkwe5cRDLvpx8GcOnja+1dmkAQ1XW/e6piexPpogNRclXn4xVaZ3C
         WOCiSonYPivGkq4ckRjdRuzYGC3iSvQtZzyT0=
Message-ID: <4D54411C.5040607@gmail.com>
Date: Thu, 10 Feb 2011 22:48:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        gorcunov@gmail.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix section mismatch in LAPIC initialization
References: <4D525C7E0200007800030EE1@vpn.id2.novell.com> <tip-2fb270f3212a1e6a73f86f76c85caee93aae4386@git.kernel.org>
In-Reply-To: <tip-2fb270f3212a1e6a73f86f76c85caee93aae4386@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2011 05:43 PM, tip-bot for Jan Beulich wrote:
> Commit-ID:  2fb270f3212a1e6a73f86f76c85caee93aae4386
...

Thanks a lot Jan!

-- 
    Cyrill
