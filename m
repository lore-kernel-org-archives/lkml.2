Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab1EXBbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:31:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab1EXBbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=x1Cp2sjwBXSZBBQ+4eVz5W2f/g57mGbohBQO+9ZYpLOIaflVNUYC0rc4jIEu5jbybx
         VyHJUZULmjcH5AyAFQM77P1zIDUSXHw5v/U61u1ULXyefi/mNFc1YjjQJeW349SZO/0M
         Y1vl/UAAQkBbnFDNWlNpuMm+Jxd6TqbVmZ+Ok=
MIME-Version: 1.0
In-Reply-To: <5210.1306200244@localhost>
References: <1306006721.1622.18.camel@anish-desktop> <1306059528.2761.3.camel@anish-desktop>
 <1306164094.2292.25.camel@anish-desktop> <1306167105.8687.11.camel@Joe-Laptop>
 <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com> <1306168598.8687.27.camel@Joe-Laptop>
 <20110523093920.8f1e5cd0.rdunlap@xenotime.net> <1306168975.8687.29.camel@Joe-Laptop>
 <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com> <1306171117.8687.34.camel@Joe-Laptop>
 <BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com> <1306174166.8687.49.camel@Joe-Laptop>
 <BANLkTimCZP0raacMazU7wWTtoAUcUE9vRQ@mail.gmail.com> <5210.1306200244@localhost>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 23 May 2011 21:31:29 -0400
X-Google-Sender-Auth: 8tuOoWBkpY0O4vsTKLVB6ovm7Lo
Message-ID: <BANLkTinwGhs0OaH7gZsyrbmL-6wMcmM2VA@mail.gmail.com>
Subject: Re: [patch v3] checkpatch: Signature format verification
To: Valdis.Kletnieks@vt.edu
Cc: Joe Perches <joe@perches.com>, anish singh <anish198519851985@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 21:24,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 23 May 2011 18:51:42 EDT, Mike Frysinger said:
>> On Mon, May 23, 2011 at 14:09, Joe Perches wrote:
>> >    167     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> personally, i dont think those quotes should be there
>
> Although not strictly required by the ABNF of RFC822 and its successors, it's
> probably a wise thing to apply the double quotes in this case anyhow, due to
> the fairly high likelyhood that some software will choke on the ' character in
> Ted's last name if unquoted.

then people will notice their software blows and they'll fix it

i dont have a problem with "over" quoting with the From/To/CC headers
in say `git format-patch` or `git send-email`, but i dont think they
make sense in s-o-b/related tags.
-mike
