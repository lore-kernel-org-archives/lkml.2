Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1IJAEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:04:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34461 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752563Ab1IJAEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:04:08 -0400
References: <1315518078-30619-1-git-send-email-mason@myri.com> <CA+55aFyFXXyEvOs0asgNeCrLzvH+e1zXgOen1rDd9BkB09J5NQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFyFXXyEvOs0asgNeCrLzvH+e1zXgOen1rDd9BkB09J5NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/2] PCI: PCI-E MPS bug fixes
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 09 Sep 2011 17:04:19 -0700
To: Linus Torvalds <torvalds@linux-foundation.org>, Jon Mason <mason@myri.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-ID: <6dad18a7-cf65-46db-8283-78b8da5bfa3a@email.android.com>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 50.0.61.98 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>Jesse,
>  what's the status of this? It does seem like our current PCIe
>behavior is rather unsafe.
>
>Should I apply the patches, should I wait for a pull request from you,
>should I ignore them because of xyz?
>
>                      Linus
>
>On Thu, Sep 8, 2011 at 2:41 PM, Jon Mason <mason@myri.com> wrote:
>> Please include these bug fixes to PCI in 3.1-rc6
>>
>>

You should apply them. I would queue them, and but I don't have another PCI tree anywhere for you to pull them. 

In fact, I'll be out for the next few weeks; I'll ask Bjorn to cover for me. 

Thanks,
Jesse
-- 
Jesse Barnes, Intel Open Source Technology Center
