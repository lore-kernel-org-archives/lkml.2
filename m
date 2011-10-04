Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1JDQvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:51:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51035 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab1JDQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <1317744493.29415.238.camel@pasglop>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
 <1317742838.29415.217.camel@pasglop> <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
 <1317744493.29415.238.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 09:51:10 -0700
X-Google-Sender-Auth: 0lBScNHyiALdEGOwsqLFyNFHGc4
Message-ID: <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 9:08 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>>
>> Well, bcrl argues that patches 1-2 of 3 are actively wrong.
>
> This is an argument that isn't finished :-)

Oh, I absolutely *hope* it isn't finished, but there's no way I'm
applying a patch for -rc9 that people are still actively arguing
whether it's at all valid or not.

Which is why I'm planning on applying 3/3 just to make the whole issue
irrelevant for 3.1, and then the people who want to test things out
can apply whatever patches they want and play with the kernel command
line options to actually enable whatever behavior they are testing.

                       Linus
