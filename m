Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0LCLWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:22:02 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:59486 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156Ab0LCLV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:21:59 -0500
From: Matteo DAMENO <matteo.dameno@st.com>
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        mems applications <mems.applications@st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Carmine IASCONE <carmine.iascone@st.com>, Greg KH <gregkh@suse.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Matteo DAMENO <matteo.dameno@st.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paolo BENDISCIOLI <paolo.bendiscioli@st.com>
Date: Fri, 3 Dec 2010 12:20:40 +0100
Subject: RE: [PATCH] input: misc: add lps001wp_prs driver
Thread-Topic: [PATCH] input: misc: add lps001wp_prs driver
Thread-Index: AcuSWAVao5n/IpRXRSO7Ur+XWsaQnwAc+BOw
Message-ID: <9BF90A6D61BF154E973D03082989295CA22B3F803A@SAFEX1MAIL3.st.com>
References: <matteo.dameno@st.com>
 <1291049009-32597-1-git-send-email-matteo.dameno@st.com>
 <20101130060926.GA31838@core.coreip.homeip.net>
 <AANLkTikpVtq2cQVhhcsJhZwGFW74mTqo=-vVK1e50AC2@mail.gmail.com>
 <9BF90A6D61BF154E973D03082989295CA22B3F7E95@SAFEX1MAIL3.st.com>
 <4CF7F66F.70808@cam.ac.uk>
In-Reply-To: <4CF7F66F.70808@cam.ac.uk>
Reply-To: Matteo DAMENO <matteo.dameno@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB3BMNhI032097


-----Original Message-----
> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
> Sent: Thursday, December 02, 2010 8:42 PM
> To: Matteo DAMENO
> Cc: Mohamed Ikbel Boulabiar; Dmitry Torokhov; mems applications; linux-
> input@vger.kernel.org; linux-kernel@vger.kernel.org; Carmine IASCONE; Greg
> KH; Guenter Roeck; Jean Delvare
> Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
> 
> Sorry for my lack of response earlier in this thread. Looks
> like my linux-input subscription has died for some reason so
> I hadn't seen it until someone kindly cc'd me.
> 
> >> -----Original Message-----
> >> From: Mohamed Ikbel Boulabiar [mailto:boulabiar@gmail.com]
> >> Sent: Tuesday, November 30, 2010 11:35 AM
> >> To: Dmitry Torokhov
> >> Cc: mems applications; linux-input@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; Matteo DAMENO; Carmine IASCONE; mems
> >> Subject: Re: [PATCH] input: misc: add lps001wp_prs driver
> >>
> >> On Tue, Nov 30, 2010 at 7:09 AM, Dmitry Torokhov
> >> <dmitry.torokhov@gmail.com> wrote:
> >>>> +      If you say yes here you get support for the
> >>>> +      STM LPS001D Barometer/Termometer on I2C bus.
> >>>
> >>> This does not belong to input subsystem, IIO is a better fit.
> >>
> >> According to this site:
> >> http://www.cnbc.com/id/40413317
> >> and its datasheet:
> >> http://www.findmems.com/wp-content/uploads/2010/11/LPS001WP-
> >> DATASHEET.pdf
> >>
> >> This sensors applications are:
> >> â–  Altimeter and barometer for portable devices
> >> â–  Smartphones
> >> â–  Indoor navigation
> >> â–  GPS applications
> >> â–  Weather station equipment
> >> â–  Sports watches
> >>
> >> "the same devices would be able to identify the precise location in
> >> all three dimensions, allowing, for example, a mobile phone to send a
> >> call to an emergency fire, medical or police service that identified
> >> not only the location of the building but also the particular floor."
> >> Identifying 3d location is similar to what many joystick are doing.
> >>
> >> Specially the indoor navigation information means an information about
> >> the user. And the information is very tied to the user.
> >> I don't know whether this can be used to map with virtual reality in a
> >> game, or where you use sensors data to give user informations when
> >> visiting a museum.
> >>
> >>
> >> Dmitry, is it possible to start putting similar drivers in a new
> >> drivers/input/sensors directory but which belongs to the input
> >> subsystem ? What do you think ?
> >>
> >
> > We agree with you.
> > It would be a good idea.
> > We are working on many device drivers that are matching your description
> and
> > we are ready to submit them.
> >
> > We are disoriented because every maintainer seems to bounce our
> submissions
> > because of inappropriate position for the device.
> >
> > IIO, input/misc, I2C (we didn't submit here because of deprecation stated
> in
> > Documentation).
> > Some one is also submitting our drivers with modifications
> > under Hwmon...
> If it's out of scope they are wasting their time so it will bounce anyway.
> Hwmon is now actively (very well) maintained so inappropriate drivers will
> get a reply quickly. (and if you are talking about the combined
> magnetometer
> and accelerometer driver submitted the other day, it already has!)
> 
> Note the big lis3* driver in there is getting kicked out to drivers/misc
> asap.
> No one seems quite sure why it went in there in the first place and it has
> been
> causing confusion ever since!  The presence of that driver is the main
> reason
> people new to these devices tend to think they should be in hwmon in the
> first
> place. (cc'd Guenter and Jean for their information)
> >
> > What to do?
> This is well within the scope of IIO, so we will be more than happy to take
> the driver and assist with any issues etc caused by the move. The other
> existing
> option is to put it in drivers/misc and wait for IIO to move out of staging
> or something else to come along. There are a few sensor drivers already
> there
> for exactly that reason.
> 
> Disadvantages of MISC:
> * Not a coherent location for drivers.  Whether things match in abi etc
> is more fluid and relies on a few people shouting when new drivers arrive.
> 
> Disadvantages of IIO:
> * User space interfaces aren't guaranteed to be stable. However, if you
> notify
> us that they need to be for a particular device we will support the current
> ones
> for a suitable period (and provide any new ones alongside).  Basically,
> it's
> taking a while to get the interfaces right though (except for new stuff) I
> think
> we are pretty close.
> * Kernel abi's probably change more than in the majority of the kernel.
> This isn't a problem if you are in tree though as we will obviously update
> the
> driver in sync with the changes.
> * One or two core elements are in need of work (the buffering code needs an
> easier to review implementation and the input bridge, in userspace needs
> some actual work beyond a proof of concept).
> 
> Conversely we have more flexibility to change things as and when we
> discover
> we got a decision wrong.  We have quite a lot of drivers so working
> on unifying interfaces is becoming easier all the time.  It's Direct
> Digital Synthesis (DDS) chips this week ;)  No merged altimeter drivers
> yet though so there will probably be some new abi elements to pin down.
> 
> Personally I don't really mind where drivers are physically located, just
> that
> we use consistent interfaces to user space where ever possible.  The
> location
> is easy to change (as it's controlled more or less by kernel developers),
> the interfaces less so as userspace applications depend on them.
> 
> Nice looking device by the way. I'll take a look at the driver shortly
> (can do a lot of review independent of the subsystem it is going in).
> 

Thank you Jonathan, 
I think that driver/misc/ could be a good place, at least at first: when
a more stable knowledge will be reached (we will try to  contribute) 
we could move them where useful.
We are going to submit all our drivers there.
Your reviews are really appreciated.
More, the are some feature to add to lps001wp.
The same applies for the accelerometer and magnetometer we are going to submit.

Please we need to know if we have to close the currently opened threads.


> Thanks,
> 
> Jonathan
> >
> > Matteo Dameno
> >
> >>
> >> i

Thanks,
Matteo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
