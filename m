Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1EXPz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:55:57 -0400
Received: from mailrelay04.solcon.nl ([212.45.32.115]:33952 "EHLO
	mailrelay04.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab1EXPz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:55:56 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 11:55:55 EDT
Message-ID: <4DDBD058.3080801@solcon.nl>
Date: Tue, 24 May 2011 17:35:52 +0200
From: Albert Pool <albertpool@solcon.nl>
Reply-To: albertpool@solcon.nl, linux-kernel@vger.kernel.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: (Short?) merge window reminder
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new major version number will reach high expectations. I think it's 
better to wait till the power issues of 2.6.38/39 are fixed and proved 
to be absent, before naming it Linux 3.0.
Anyway, wouldn't it be a great date to release Linux 3 on August 21, 
2011? I know it's hard to achieve this exact date with a stable 3.0. If 
you don't think a fixed date for a stable version is a good idea, you 
could release the first RC of 3.0 on that date.

About the scripts: if they don't like the version number to be 1 digit 
shorter, why not append an extra .0 to uname? This digit can be used for 
bugfix releases, like 2.6.38.7. In the current system, an extra digit is 
added for those releases. But if that extra digit will always be there, 
and is 0 by default, scripts won't care about the lack of a 3rd digit. 
Then, the 3.0 will be 3.0.0, with new releases (current 3rd digit) being 
3.1.0, 3.2.0, ..., and bugfix releases (current 4th digit) being 3.0.1, 
3.0.2, .... It might be a bit confusing after the switch, but if we 
change to a 2-digit number, it's confusing too.
Scripts recognizing bugfixes as new releases is a smaller disaster than 
scripts crashing or returning errors due to the lack of a 3rd digit.

I agree with Jon Smirl that it could be probably better to release 2.8 
first, but there's also a good side on switching to 3.0. We are skipping 
2.7, that means our version numbering system already changes a bit. Why 
not change it completely then?

Sorry if I've missed out some discussion about this, I am not 
subscribed. I have only read some messages in the LKML archive.

Albert Pool

On Tue, May 24, 2011 at 15:48:39 +0100, Ralf Baechle wrote:

On Mon, May 23, 2011 at 07:17:21PM -0400, Ted Ts'o wrote:

>  >  So I'm toying with 3.0 (and in that case, it really would be "3.0",
>  >  not "3.0.0" - the stable team would get the third digit rather than
>  >  the fourth one.
>
>  If we change from 2.6.X to 3.X, then if we don't change anything else,
>  then successive stable release will cause the LINUX_VERSION_CODE to be
>  incremented.  This isn't necessary bad, but it would be a different
>  from what we have now.

It will require another bunch of changes to scripts that try to make sense
out of kernel Linux version numbers.  It's a minor issue and we might be
better off doing something else than version number magic.  Not last a
new major version number raises expectations - whatever those might be.

   Ralf


