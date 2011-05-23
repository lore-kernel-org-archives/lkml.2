Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab1EWWwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:52:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab1EWWwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jR1PcEEcayVn2Y1PHgoLYtW0hzgUj9n8hucax/9uzoHBhue75XmZQkRB+ycr8ko0I3
         nFcZkhvWaYzgBR/Glej+cuISEW7MVerEcY2osJ5LU65Cxay5We0mRM5GLm6xQ8X3M3P0
         EKDinV9uuL4q/K07Y6SttQR3YbS6VfMlfJRUk=
MIME-Version: 1.0
In-Reply-To: <1306174166.8687.49.camel@Joe-Laptop>
References: <1306006721.1622.18.camel@anish-desktop> <1306059528.2761.3.camel@anish-desktop>
 <1306164094.2292.25.camel@anish-desktop> <1306167105.8687.11.camel@Joe-Laptop>
 <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com> <1306168598.8687.27.camel@Joe-Laptop>
 <20110523093920.8f1e5cd0.rdunlap@xenotime.net> <1306168975.8687.29.camel@Joe-Laptop>
 <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com> <1306171117.8687.34.camel@Joe-Laptop>
 <BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com> <1306174166.8687.49.camel@Joe-Laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 23 May 2011 18:51:42 -0400
X-Google-Sender-Auth: UZPV7qA4ILQ2-nWmh2Sj-17DogM
Message-ID: <BANLkTimCZP0raacMazU7wWTtoAUcUE9vRQ@mail.gmail.com>
Subject: Re: [patch v3] checkpatch: Signature format verification
To: Joe Perches <joe@perches.com>
Cc: anish singh <anish198519851985@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 14:09, Joe Perches wrote:
>    167     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

personally, i dont think those quotes should be there
-mike
