Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1EKQUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:20:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40942 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1EKQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pqVczMthWPOlJeio7h0cab+TW09zGGq2t6Y3v/2DLHWiGAIfA6gMPnWu3MblRhYoE1
         Hyoi02VIZ5ATyYJy7rAcdjFwlP629PzRqSoujzaOjdbB5hHK9eAiYGP3PSqwLDAA1Po6
         okHNcCFQmyVxcn4Iv5P1XxUqmbMlBu3MsP6YQ=
Message-ID: <4DCA1C23.30107@gmail.com>
Date: Tue, 10 May 2011 22:18:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 v2]Typo: change kenrel to kernel.
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1105101015440.28291@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1105101015440.28291@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 01:16 AM, Jiri Kosina wrote:
> On Sun, 17 Apr 2011, Justin P. Mattock wrote:
>
>> The below patch is a resend due to rebasing to the current Mainline, in
>> of which changes a typo "kenrel" to "kernel".
>
> I have folded all the patches into one, dropped the staging/ bits (which
> wouldn't apply in -next anyway), and applied.
>

o.k... thanks for picking those up.. if I run into any others I will 
send them on up..

Justin P. Mattock
