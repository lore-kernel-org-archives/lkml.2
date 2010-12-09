Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0LIW2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:28:16 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:47956 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LIW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:28:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tzRypy/6hzfgqgKJDtNlBUI0V91XgWqjAFjdhkqwH8gpo7J2iSWnzeiBrO/+P/Z38s
         HszumEiL5IRf8JkyPtYt1n8gL7zqCEMDyfKPbtXitutrwH+x38/YDq6OUTBOGdCSh3pb
         JAeObcqDJeeWA1CYauccInX2YfHupUVtO5B7M=
MIME-Version: 1.0
In-Reply-To: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
References: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Dec 2010 14:27:53 -0800
Message-ID: <AANLkTimUZxEpT_2a9FnTNBAR2aXqcTX5KOuyN5sTwkBq@mail.gmail.com>
Subject: Re: Start dropping PCMCIA from compat-wireless for 2.6.38+
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 2:20 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I'm going to start dropping PCMCIA stuff from compat-wireless as I
> don't think we have any users of it nor interest to keep backporting
> it. This entails dropping drivers like orinoco, b43 PCMCIA support,
> libertas, as well as bluetooth bluecard_cs, bluecard_cs, dtl1_cs,
> bt3c_cs and of course CONFIG_SSB_PCMCIAHOST. If you are a user please
> yell now.

Well Haukes just sent me a patch to update some stuff so PCMCIA is
saved until further notice :)

 Luis
