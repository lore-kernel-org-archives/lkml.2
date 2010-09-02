Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0IBUra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:47:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39445 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab0IBUr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=C0i0YRQqJ1XGtYs47VAQ5Pd5duPX//1quFSkrIdm3dNlI7YkzrGdfD7mlGBMz0WgOV
         OIJydycpg9d0bqE4N+KotFpTnpPPu9aALzsFCx18aaxIP5o8ybHOykC/pINAn2XJRfi/
         bsmzZ3J4QIXisWbWknPqKoOvbAsQSeS0EWimQ=
MIME-Version: 1.0
In-Reply-To: <4C800559.10701@oracle.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
 <4C800266.1000005@oracle.com> <AANLkTineHC5C=Sv5uZezx7-RF3_rQOJFBePhfzD6jfMF@mail.gmail.com>
 <4C800559.10701@oracle.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 2 Sep 2010 17:47:08 -0300
Message-ID: <AANLkTinMOs7WJgvh60apAqFCCxraMtiCsJW6ZbBarWyy@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 17:13, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> That will require a lot more detailed review IMO.
> Usually it is good to have, but not nearly as important as user-visible strings.
>
> And you should copy trivial@kernel.org on the patch.

Ok, I'll do in the v2 of this patch


-- 

Lucas De Marchi
