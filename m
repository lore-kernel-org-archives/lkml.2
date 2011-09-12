Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1ILOBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:01:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60037 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab1ILOB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110911141040.GA23339@infradead.org>
References: <20110907175952.GC23829@thinkpad-t410> <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
 <20110908162303.GA18435@ubuntu-NB505> <CAG1a4rvfajX8BwbL39UP5PYcwMLi_GETS3psq7cZv48UvZv0Ng@mail.gmail.com>
 <20110911141040.GA23339@infradead.org>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Mon, 12 Sep 2011 10:00:58 -0400
Message-ID: <CAG1a4rubbzvOE3KoGmc_9svS-UFX8gzuE=3TnVYfGAeXCJpLYw@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Christoph Hellwig <hch@infradead.org>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Christoph Hellwig <hch@tuxera.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 10:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Sep 10, 2011 at 11:32:15PM -0400, Pavel Ivanov wrote:
>> Seth, Christoph,
>>
>> I've just found another wrong pointers freeing. The following patch
>> should fix it.
>
> I'd like to throw this into Seths previous patch, while adding an
> ACK for your finding.  Is that fine with you?

Yes, that's fine with me.


Pavel
