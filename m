Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab2AUTjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:39:39 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43527 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750941Ab2AUTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:39:38 -0500
Message-ID: <4F1B222D.4070002@xenotime.net>
Date: Sat, 21 Jan 2012 12:38:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Beller <stefanbeller@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Include the git way into Documentation/SubmittingPatches
References: <CALbm-EbAoDGyMpu7JOjk8t=2=Sn9PKS9EEuo8Gut8rwXpDQHmw@mail.gmail.com>
In-Reply-To: <CALbm-EbAoDGyMpu7JOjk8t=2=Sn9PKS9EEuo8Gut8rwXpDQHmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 10:05 AM, Stefan Beller wrote:
> I was quite confused when doing my first patch for linux
> and the documentation told me to use "diff -up" instead of
> git add/commit.
> 
> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>


Can anyone comment on how accurate this is?
Thanks.


> ---
>  Documentation/SubmittingPatches |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 4468ce2..43acf99 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -20,9 +20,14 @@ Documentation/SubmittingDrivers.
>  SECTION 1 - CREATING AND SENDING YOUR CHANGE
>  --------------------------------------------
> 
> +The steps 1) - 3) can be either performed using the diff utility or
> +using git, the distributed revision control used by the kernel developers.
> +Using git is easier, but you need it installed of course.
> +So either follow steps 1a), 2a) and 3a) utilising the diff method
> +or just 3b) using git.
> 
> 
> -1) "diff -up"
> +1a) "diff -up"
>  ------------
> 
>  Use "diff -up" or "diff -uprN" to create patches.
> @@ -82,8 +87,7 @@ Instead of these scripts, quilt is the recommended
> patch management
>  tool (see above).
> 
> 
> -
> -2) Describe your changes.
> +2a) Describe your changes.
> 
>  Describe the technical detail of the change(s) your patch includes.
> 
> @@ -111,7 +115,7 @@ If the patch fixes a logged bug entry, refer to
> that bug entry by
>  number and URL.
> 
> 
> -3) Separate your changes.
> +3a) Separate your changes.
> 
>  Separate _logical changes_ into a single patch file.
> 
> @@ -131,6 +135,20 @@ in your patch description.
>  If you cannot condense your patch set into a smaller set of patches,
>  then only post say 15 or so at a time and wait for review and integration.
> 
> +3b) Using git
> +
> +If you have followed 1a) 2a) and 3a), skip this step.
> +
> +Use "git add -i" to add all separate _logical_ changes (as described in 3a)
> +to the index of git.
> +
> +Use "git commit" to commit all added changes into the revision control.
> +A texteditor (vi, nano or graphical) will appear, which should be used to
> +describe the changes. Describe the technical detail of the change(s)
> +your patch includes. (see 2a for explanation of "technical changes")
> +
> +Use "git format-patch HEAD~1" to put your changes and your description
> +into a single textfile.
> 
> 
>  4) Style check your changes.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
