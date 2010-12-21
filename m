Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab0LUBHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:07:37 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:59486 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab0LUBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LGUjye/xbFi8OJuonSF7VYIqtqwl167wGo/IbRPKMZQ1JnqOx5RwHbARqfGYYmInzK
         fcOiAdEOddwT03MrnjCnnAA5VK9fwcczcMeRBX+dP9E0QUaG5AiM+LXNlLHPS52HWDI7
         Bx4c3Y3NC9Dtug6BEDtHLArxUsJ/CM0Px5cqg=
MIME-Version: 1.0
In-Reply-To: <20101220222446.GA8629@hexapodia.org>
References: <20101220222446.GA8629@hexapodia.org>
Date: Tue, 21 Dec 2010 03:07:33 +0200
Message-ID: <AANLkTikjuoiCJvbBTLuyh3-d=QRyVVdatc4Ybcx5UOdf@mail.gmail.com>
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 12:24 AM, Andy Isaacson <adi@hexapodia.org> wrote:
> I have a directory with 1.2M files in it, which makes readdir very slow
> on btrfs with cold caches (although it's reasonably fast with hot caches
> as in the first example below):

Sounds like:

Bug 21562 - btrfs is dead slow due to fragmentation
https://bugzilla.kernel.org/show_bug.cgi?id=21562

-- 
Felipe Contreras
