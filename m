Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0HDNeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:34:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50388 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab0HDNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M6NcoNCU03opIsUQbUzvticJGwrlmA/9Y8O40EifoE99MgaauWXStrJTxgMRb+0+GA
         7/Gama8TY0oLX+GsoFKpeP6PDSnI0wTkzbXvYOacfl5NIjNKEn1QCEK6xEUH6yR9ePOi
         ZINcyRMUn2omakNjBihY3UTmKL6ImOYctsJVQ=
Message-ID: <4C596C75.9070505@gmail.com>
Date: Wed, 04 Aug 2010 06:34:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH]Documentation update broken web addresses.
References: <1279943484-31069-1-git-send-email-justinmattock@gmail.com> <4C547464.6000505@gmail.com> <alpine.LNX.2.00.1008041521480.29919@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1008041521480.29919@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 06:22 AM, Jiri Kosina wrote:
> On Sat, 31 Jul 2010, Justin P. Mattock wrote:
>
>> any ideas on the status of this?
>
> I have now applied it. Please keep in mind, for your future submissions,
> to make sure that you handle UTF-8 correctly. I had to manually fix your
> patch for files in Japaneese, Korean and Chineese languages.
>
> Thanks,
>

thanks!!
yeah I did see those where churned up, but couldnt figure out why 
sending individually the language came out fine, but with the whole lot 
the churn would happen.

just to make sure there was a change(not sure if you received my 
previous post) with an address at:

Documentation/filesystems/affs.txt
(https://patchwork.kernel.org/patch/113264/)

this address seems to be a better location
http://www.amigaemulator.org/

wanted to wait until if I received other such changes before resending 
again, but it's too late it's already applied

Justin P. Mattock
