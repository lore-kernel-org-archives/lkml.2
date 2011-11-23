Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab1KWG1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:27:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab1KWG1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:27:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111122222048.GF24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-7-git-send-email-corentincj@iksaif.net>
	<20111122222048.GF24283@suse.de>
Date: Wed, 23 Nov 2011 07:27:35 +0100
Message-ID: <CAHR064i7sVOyGdhbSAj8gCeTqpYeGuJUd_q_=On+K8j32R9vEw@mail.gmail.com>
Subject: Re: [PATCH 06/15] samsung-laptop: add small debugfs interface
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:20 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:37PM +0100, Corentin Chary wrote:
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>
> You should describe what the debugfs interface does please.
>
> I have an idea, and I like it a lot, but still, it would be nice to let
> the others know :)
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>

It's in the code:

+/*+ * samsung-laptop/    - debugfs root directory+ *   f0000_segment
  - dump f0000 segment+ *   command          - current command+ *
data             - current data+ *   d0, d1, d2, d3   - data fields+ *
  call             - call SABI using command and data+ */
But maybe I should add it to the changelog and add an example on how to use it.

But yeah, it was very useful for experimentation.

-- 
Corentin Chary
http://xf.iksaif.net
